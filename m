From: Patrick Schaaf <bof@bof.de>
Subject: Re: netfilter hook function error...
Date: Wed, 21 Sep 2005 07:51:21 +0200
Message-ID: <20050921055121.GA25193@oknodo.bof.de>
References: <a60102c3050920171352ae872c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: JC <bikkit@gmail.com>
Content-Disposition: inline
In-Reply-To: <a60102c3050920171352ae872c@mail.gmail.com>
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

Hi JC,

welcome to "introduction to C". This is NOT a usual service of
this mailing list. Anyway...

> /home/jc/code/spider/spider.c:126: warning: ISO C90 forbids mixed
> declarations and code
>   print_string("Packet reached IN_HOOK.");
>   struct iphdr *my_ipheader;

In traditional C, a variable declaration (like your my_ipheader)
MUST COME BEFORE ANY OTHER CODE IN A FUNCTION (like your print_string
call)

> /home/jc/code/spider/spider.c:134: warning: passing argument 1 of
> 'print_string' discards qualifiers from pointer target type
> 	  print_string(out->name);

Not that I really know, because you have not shown your print_string()
function prototype, but I bet that you made its first argument be
a 'const char *', and out->name is a 'char *' without the 'const'.

> /home/jc/code/spider/spider.c:150: error: request for member 'nh' in
> something not a structure or union
> 	      my_ipheader = skb->nh->iph;

The compiler complains that the skb thing is not pointer to a structure.
Which is correct. It is a pointer to a pointer to a structure. So you
need to dereference it once, like '(*skb)->nh->iph'. However, I'm
not sure that nh->iph is valid in all cases. Look at other hook
functions which need the IP header.

best regards
  Patrick
