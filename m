From: Emanuel Heidinger <heidinge@informatik.tu-muenchen.de>
Subject: Re: libiptc: the question about struct ipt_entry
Date: Mon, 21 Oct 2002 13:55:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DB3EB44.C8C4BDF7@informatik.tu-muenchen.de>
References: <LLEJLJOMFGPFJFEGAKBJOENPCCAA.luoqiang@ict.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: luoqiang <luoqiang@ict.ac.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

>     2.  For target in this example, the total size is 52, 32 of which is the sizeof struct ipt_entry_target,
> I don't know what struct should be for the other 20 bytes, which is pointed  by target->data. and I think
> it should store the information about " --to 10.10.5.9:5000". Some one can tell me what struct it is ?
> 
>  (the size of the match and the target is get by match.u.user.match_size and target.u.user.target_size .)


i think it's the struct called ip_nat_multi_range...
have a look at extensions/libipt_DNAT.c &
<linux/netfilter_ipv4/ip_nat.h>

cheers, emanuel 

well, some code ...
		      struct ip_nat_multi_range *__t;
		      __t = (ip_nat_multi_range *) __x->data;	
		      
		      char to_dst[QSTR_MAX_LENGTH];
		      
		      struct in_addr min,max;
		      for (unsigned int i=0;i<__t->rangesize;i++) {
			if (__t->range[i].flags & IP_NAT_RANGE_MAP_IPS)
			  {
			    min.s_addr = __t->range[i].min_ip;
			    max.s_addr = __t->range[i].max_ip;
			    snprintf(to_dst,QSTR_MAX_LENGTH,"%s",inet_ntoa(min));
			    
			    if (min.s_addr!=max.s_addr) {
			      snprintf(buffer,STR_MAX_LENGTH,"-%s",inet_ntoa(max));
			      strncat(to_dst,buffer,QSTR_MAX_LENGTH-strlen(to_dst));
			    }
			  }
