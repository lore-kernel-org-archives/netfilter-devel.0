From: Vinod Chandran <vinod_chandran@multitech.co.in>
Subject: Dropping while getting PREROUTING hook
Date: Tue, 01 Feb 2005 13:26:48 +0530
Message-ID: <41FF3640.5020001@multitech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi all ,

I need FTP PORT command with invalid ip to be dropped. I did certain 
modifications in ip_conntrack_ftp.c, where the checking of the PORT 
command is done , and if its an invalid ip , I return NF_DROP instead of 
NF_ACCEPT.


if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
       == ct->tuplehash[dir].tuple.src.ip) {
       exp->seq = ntohl(tcph->seq) + matchoff;
       exp_ftp_info->len = matchlen;
       exp_ftp_info->ftptype = search[i].ftptype;
       exp_ftp_info->port = array[4] << 8 | array[5];
   } else {
       /* Enrico Scholz's passive FTP to partially RNAT'd ftp
          server: it really wants us to connect to a
          different IP address.  Simply don't record it for
          NAT. Vinod - Commented the next two lines
       DEBUGP("conntrack_ftp: NOT RECORDING: %u,%u,%u,%u != %u.%u.%u.%u\n",
              array[0], array[1], array[2], array[3],
              NIPQUAD(ct->tuplehash[dir].tuple.src.ip)); */

       /* Thanks to Cristiano Lincoln Mattos
          <lincoln@cesar.org.br> for reporting this potential
          problem (DMZ machines opening holes to internal
          networks, or the packet filter itself). */
       /* Vinod - Commented the next line  and added two lines of code*/
       /*if (!loose) goto out;*/
       DEBUGP("DROP should be done\n");
       printk("Again\n");
       UNLOCK_BH(&ip_ftp_lock);
       return NF_DROP;
   }


This return value is checked in the call ip_conntrack_in ( 
ip_conntrack_core.c), I have modified it so that when the value returned 
is NF_DROP, nf_conntrack_put is called to destroy the conntrack.

if (NF_DROP == ret) {
           /*atomic_set((*pskb)->nfct->master->use,1);
           nf_conntrack_put((*pskb)->nfct);*/
           (*pskb)->nfct->master->destroy((*pskb)->nfct->master);
           (*pskb)->nfct = NULL;
           DEBUGP("Are we here?\n");
           return NF_DROP;


However with all these modifications the packet is still getting 
forwarded, in short never getting dropped. I have seen places in ftp 
helper itself where NF_DROP was getting returned, I wonder if they are 
working too.
I have seen the packets reaching the DROP case in nf_hook_slow, without 
any success.

I am sending the packet from the LAN side and the FTP server is 
connected to the WAN interface.

Is there something that I am missing out or PREROUTING conntrack cannot 
drop packets?

Thanks and Regards,
Vinod C
