From: dmorris <dmorris@metavize.com>
Subject: Re: [PATCH?] Fix getorigdst() in ip_conntrack_core.c on 2.4.22-ac2
Date: Wed, 10 Sep 2003 15:29:40 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5FA5D4.9030202@metavize.com>
References: <20030910212715.80212.qmail@web40906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Chapman <kakadu_croc@yahoo.com>
In-Reply-To: <20030910212715.80212.qmail@web40906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>Would this work, or would it be horribly worse? Where can I get an app which uses
>SO_ORIGINAL_DST to test this out?
>
>  
>

Try this:

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <linux/netfilter_ipv4.h>

int main ()
{
    int sock;
    int one = 1;
    struct sockaddr_in addr;
   
    if ((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP))<0)
    {perror("socket()");exit(-1);}

    setsockopt(sock, SOL_SOCKET,SO_REUSEADDR,(char *)&one,sizeof(one));

    memset(&addr,0,sizeof(addr));
    addr.sin_port = htons(1234);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(sock, (struct sockaddr*)&addr, sizeof(addr))<0)
    {perror("bind()");exit(-1);}
 
    if (listen(sock, 3) < 0)
    {perror("listen()");exit(-1);}
   
    while(1) {
        int addrlen = sizeof(addr);
        int fd = accept(sock,(struct sockaddr*)&addr,&addrlen);
       
        if (fd < 0)
        {perror("accept()");exit(-1);}
      
        printf("accepted.");
       
        if (getsockopt(fd,SOL_IP,SO_ORIGINAL_DST,&addr,&addrlen)<0)
        {perror("getsockopt()");exit(-1);}

        printf("original dest: 
%s:%i\n",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));

        close(fd);
    }
   
}





then do:
s iptables -t nat -A PREROUTING -p tcp --destination-port 7 -j REDIRECT 
--to-port 1234

then from some machine behind that machine
"telnet 128.2.1.2 7"
Trying 128.2.1.2...
Connected to 128.2.1.2.
Escape character is '^]'.
Connection closed by foreign host.

the machine running the code above should print:
accepted.original dest: 128.2.1.2:7


and from the localmachine
telnet localhost 1234

the code should say:
accepted.original dest: 127.0.0.1:1234

goodluck,

-dirk morris
