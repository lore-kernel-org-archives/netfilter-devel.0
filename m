From: "Swaroop Ashish" <sashish@novell.com>
Subject: Unable to receive data Netlinks sockets
Date: Wed, 24 Mar 2004 23:07:38 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <s06214ce.076@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I am new to Iptables/Netfilter. I want to write a test program to
receive all the packets recieved on the system via this test program
using Netlinks sockets.  Can anyone please tell me what is wrong in the
following program and what configuration/rules should be added to
Iptables to do the same.

I think the way I am using recvmsg has to be handled in some other way
..any clues on that????

Thanks in advance,
Ashish

#include <stdio.h> 
#include <asm/types.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <netinet/ip.h>
#include <net/ethernet.h>
#include <linux/socket.h>
#include <linux/netlink.h> 
#include <linux/rtnetlink.h> 
#include<net/if.h>

int sigflag;
int main()
{
	
        struct iovec iov;
	struct sockaddr_nl nladdr;	/* NetLink Socket Address */
   	struct msghdr nlhdr;

	int	sigio_func();
	

	int sd;				/* NetLink Socket */
	char msgbuff[65535];
	int length;
	int status;

//initialise the buffer 
	memset((char *)&nladdr,0,sizeof(nladdr));
	memset((char *)&nlhdr,0,sizeof(nlhdr));

signal(SIGIO,(void *)sigio_func);

//Create a NetLink Socket

	sd = socket(AF_NETLINK, SOCK_RAW, NETLINK_FIREWALL);
	if(sd <0){
		printf("Error in Socket creation");
		exit(0);}
	
// Fill up the address strucure
	nladdr.nl_family=AF_NETLINK;
	nladdr.nl_pid=0;
	nladdr.nl_groups=-1;

//bind the socket

	if((bind(sd,(struct sockaddr *)&nladdr,sizeof(nladdr)))<0){
		printf("Error in BIND\n");
		exit(0);}
		
	// Receive the message from the socket


if(fcntl(0,F_SETOWN,getpid())<0)
{
	printf("F_SETOWN Problem");
	exit(1);
}

if(fcntl(0,F_SETFL,FASYNC)<0)
{
	printf("F_SETFL Problem");
	exit(1);
}


//recvmsg returns the structure nlhdr which in turns has the control
message structure and that too is protocol
//specific. This struct almost maps to the Netlink Message header.

	

    while (1) 
	{
	
		sigblock(sigmask(SIGIO));	//Block the signal till
I/O happens
		while(sigflag ==0)
			sigpause(0);
		
		iov.iov_base=msgbuff;
		iov.iov_len=sizeof(msgbuff);
		
		nlhdr.msg_name= (void *)&nladdr;
	        nlhdr.msg_namelen= sizeof(nladdr);
		nlhdr.msg_iov=&iov;
		nlhdr.msg_iovlen=1;
		nlhdr.msg_control=(void *)NULL;
		nlhdr.msg_controllen=0;
		nlhdr.msg_flags=0;
                
		printf("You are just b4 recvmsg");                      
                                                                        
              
		status =recvmsg(sd,&nlhdr,0); 
                                                                       
                                                   
        	if (status < 0)
        	{
			 if (errno == EINTR)
		                continue;
		         printf( "netlink recvmsg overrun" );
		}
                                                                       
                                                      
        	if (status == 0)
		{
            		printf( "netlink EOF. Exiting." );
                        exit(1);
		}
                                                                       
                              
	        if (nlhdr.msg_namelen != sizeof nladdr)
		{
			printf( "netlink sender address length error:
length %d",nlhdr.msg_namelen);
                	exit(1);
		}                                                       
                                                      
	        if (nlhdr.msg_flags & MSG_TRUNC)
        	{
            		printf( "netlink error: message truncated" );
            		continue;
	        }
     	/* Got netlink packet */
		printf("Packet is %s \n",iov.iov_base);       
    		
		sigflag=0;		//Set the signal flag to zero
		sigsetmask(0);		//disable the signal mask
	}

return 0;
}

int sigio_func()
{
	sigflag=1;}
