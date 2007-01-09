From: "safiudeen" <safiudeen@todaktech.com>
Subject: Re:Network compression...
Date: Tue,  9 Jan 2007 14:08:30 +0800
Message-ID: <200701091408.AA503644674@todaktech.com>
Reply-To: safiudeen@todaktech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
I used netfilter hook to cmpress/uncompress TCP/IP payload that comes and leave the NIC of a network connected pc. This works perfactly for HTTP and  ICMP packets when test between to compressed netfilter hooked PCs. FTP is not working. Client side hangs even it recive complete compressed packet from server. And  same packet is being keep on transmitting from server.
Followings are the short of code I used in incomming and out going hooks

Outgoing data hook
=====================
hook function :      ipcomp_out_hook
hook type     :      NF_IP_POST_ROUTING

Followings are the major part of ipcomp_out_hook codes
-------------------------------------------------------

 spin_lock(compress);
        cpyldsz = ipcomp_Compress((char *) iph + iphlen,comp_buff,pyldsz);
        spin_unlock(compress);

 ((struct ipcomphdr*) ((char*) iph + iphlen))->ipcomp_nh = iph->protocol;
        ((struct ipcomphdr*) ((char*) iph + iphlen))->ipcomp_flags = 0;
        ((struct ipcomphdr*) ((char*) iph + iphlen))->ipcomp_size = (__u16)pyldsz ;

iph->protocol = IPPROTO_COMP;
        iph->tot_len = htons(iphlen + sizeof(struct ipcomphdr) + cpyldsz);
                                                                                                                             
        memcpy((char *) iph + iphlen + sizeof(struct ipcomphdr), comp_buff, cpyldsz);
        kfree(comp_buff);
        iph->check = 0;
        iph->check =  ip_fast_csum((u8 *)iph,iph->ihl);
        skb_put(skb,cpyldsz + sizeof(struct ipcomphdr) - pyldsz);
        return NF_ACCEPT;



Incomming data hook
=====================
hook function :       ipcomp_in_hook
type          :       NF_IP_PRE_ROUTING

Followings are the major part of the ipcomp_in_hook codes
----------------------------------------------------------

                        spin_lock(compress);
                        len = ipcomp_Uncompress((char *) iph + iphlen + sizeof(struct ipcomphdr),uncomp_data,cpyldsz ,pyldsz);
                        spin_unlock(compress);
                                                                                                                             
                        iph->tot_len = htons(iphlen + len);
                        iph->protocol = ((struct ipcomphdr*) ((char*) iph + iphlen))->ipcomp_nh;
                        iph->check = 0;
                        iph->check = ip_fast_csum((char*) iph, iph->ihl);
                        memcpy(skb->data + iphlen,uncomp_data,pyldsz);
                        skb_put(skb,pyldsz - cpyldsz - sizeof(struct ipcomphdr));



Here ipcomp_Compress and ipcomp_Uncompress are the compression routins.These routin uses Lembel-ZIV algorithm to compress and decompress  IP paylod.

And struct ipcomphdr as follows
struct ipcomphdr {                      
    __u8    ipcomp_nh;     
    __u8    ipcomp_flags;   
    __u16   ipcomp_size;    
};

this ipcomphdr comes next to ip header in a compressed packet.
The above code I wrote based on openswan IPCOMP

Regarding my FTP packet do I have to some more work interm of checksums ?
Currently in this compression I only handling ipheader chechksum.
Please anyone help me to figure out the cause of this FTP client hanginh problem. 

Thank you
Safiudeen
