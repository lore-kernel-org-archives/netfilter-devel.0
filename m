From: "raquel toribio" <raqueltoribio@hotmail.com>
Subject: Problems using iqp_read
Date: Mon, 25 Nov 2002 20:25:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F52eNTdiSbxl4ggadKT00025cdc@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,
Hi. I am quite new into Linux programming and I am having some difficulties 
trying to develop a userspace program that should intercept packets that are 
for the QUEUE target of the iptables.
I've created a program using the socket netlink, and libipq, but it fails to 
receive correct packets:  ipq_message_type(packet) returns NLMSG_ERROR, and 
ipq_errstr() returns Unknown error.
Does anybody know why this could be hapenning?
Any hint will be very appreciated!!
The code I have is the following: 
________________________________________________________
int main(void)
{    struct ipq_handle *h=NULL;
        int rval=0;
        unsigned char packet[65536];
        memset(packet, 0, 65536);
        if ((h = ipq_create_handle(0, PF_INET)) == NULL) exit(1);
        rval = ipq_set_mode(h, IPQ_COPY_META, 0);
        if (rval < 0) goto die;
        while (rval >= 0)
        {
        	int mType = 0;
        	rval = ipq_read(h, packet, sizeof(packet), 0);
        	 switch (mType = ipq_message_type(packet))
                {
                	case IPQM_PACKET:
                	{
                                ipq_packet_msg_t *m = 
ipq_get_packet(packet);
                                int verdict = NF_ACCEPT;

                               if (m->data_len == 200)  verdict = NF_DROP;
                                ipq_set_verdict(h, m->packet_id, verdict, 
m->data_len, m->payload);
                                             break;
                        }
               		case NLMSG_ERROR:
               		{

                        fprintf(stderr,  "Received error message: %s, 
messageType = %d\n", ipq_errstr(), mType);
                        rval = -1;
                        break;
                        }
                        default:
                        rval = -1;
                        fprintf(stderr, "Unknown message type %d!\n", 
mType);
                        break;
                }
        }
    die:
	printf("Die\n");
        ipq_destroy_handle(h);
        exit(1);
}
______________________________ End of code

Thanks,
Raquel




_________________________________________________________________
Charla con tus amigos en línea mediante MSN Messenger: 
http://messenger.microsoft.com/es
