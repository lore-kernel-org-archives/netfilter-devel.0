From: Garrick il Bardo <miseriaccia@yahoo.it>
Subject: NF_IP_POST_ROUTING hook & sk_buff struct
Date: Fri, 19 Oct 2007 13:46:28 +0200 (CEST)
Message-ID: <892457.37213.qm@web32707.mail.mud.yahoo.com>
References: <20071019104639.1ebl44pdk4ooo4ck@mail.krutibrko.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20071019104639.1ebl44pdk4ooo4ck@mail.krutibrko.sk>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
if I write a NF_IP_POST_ROUTING hook (for kernel
2.6.21) to SNAT some TCP packets, can I suppose that
(for TCP packets) TCP Payload is contiguous to TCP
Header in struct sk_buff (payload pointer = skb->h->th
+ (skb->h->th->doff * 4) ) ? If not, is there a
function that assure me this result ?

I'm writing a NF_IP_POST_ROUTING hook for kernel
2.6.21, but it does right SNAT and checksum
calculation only for TCP packet without payload,
because TCP payload seems to be not contiguous to TCP
Header in struct sk_buff!

Thanks,
Maurizio


---
Maurizio


(o<                                    (@_
//\                                    //\
V_/_....Powered By Ubuntu GNU/Linux....V_/_


      ___________________________________ 
L'email della prossima generazione? Puoi averla con la nuova Yahoo! Mail: http://it.docs.yahoo.com/nowyoucan.html
