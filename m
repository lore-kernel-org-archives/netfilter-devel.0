From: zhi wang <pangy2004@yahoo.com>
Subject: Re: size of a rule
Date: Mon, 26 Apr 2004 07:12:45 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040426141245.52053.qmail@web41709.mail.yahoo.com>
References: <408D1482.5030009@aiqa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <408D1482.5030009@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> #define list_entry(ptr, type, member) \
>         ((type *) ( (char *)(ptr)-(unsigned long)(&((type *)0)->member) ) )
> 
> What is the meaning of ((type *)0)->member ? I can not understand the 
> part with 0.  
This is a common trick in Linux. I first saw it in 4.4BSD source codes. Here,
the type is often a structure, for example,
struct foo{
     int bar1;
     int bar2;
};
then 
(struct foo*)0 coverts zero to a point to struct foo, suppose:
    struct foo* p = (struct foo*)0;
then &((struct foo*)0)->bar2 is:
    &p->bar2
which get the address of bar2. 
Becase p equals to zero, so the address of bar2 is also the offset of bar2 in
the structure foo.
So, &((type*)0)->member yields the offset of member in type.

If you want to find the size of a rule, try this command:
          iptables -L -vvv
This command shows the details of filter tables rules. It aslo gives the
structure of iptable. If you want to read the source codes, It will help a lot.


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
