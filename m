From: "=?ISO-8859-1?Q?Daniel_Corr=EAa_de_A?=zevedo" <nielca@linkexpress.com.br>
Subject: Re: /proc/net/ip_conntrack
Date: Wed, 30 Jun 2004 11:28:25 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630130806.M61849@linkexpress.com.br>
References: <20040629203549.M8283@linkexpress.com.br> <Pine.LNX.4.44.0406301236030.3767-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0406301236030.3767-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   Hi Henrik. 
 
> > I wonder if any one could help me with figuring out a way to write to the  
> > proc file "/proc/net/ip_conntrack". 
>  
> You can't. It is not a file, it is a window into the connection  
> tracking function of the kernel showing you what is going on "right  
> now". This window is bulletproof and you cant take things out or put  
> things in via this window, only look at how they look. 
 
  I've just figured that out spending the hole night studing ip_conntrack source. Since I'm 
really starting with advanced programming, it took me some time to figured out that 
ip_conntrack matching works as a LKM (Loable Kernel Module) and that to write to the 
/proc/net/ip_conntrack file, it should be a LKM too. 
  Tough, I still wonder if is there a solution to this problem. I was thinking of LKMs and 
wondering if it is possible to one write a LKM that interacts with the ip_conntrack LKM to 
write entries to /proc/net/ip_conntrack? Or even write directly to it? 
   I've just loaded ip_conntrack LKM indirectly by inserting a statefull rule to iptables and 
checkout what symbols it makes available. There are a few that, by their names, looks like 
inserts entries to ip_conntrack file (just guessing), like: 
 
d0901c50  GPLONLY_ip_conntrack_put_Re9c6735e  [ip_conntrack] 
 
   Any way, what do you think about this? Does it sound like nonsense (I've just my first 
contact with LKM...) or it maybe possible? 
 
>  
> > What I need is to replicate this file  
> > from one computer to another. 
>  
> See discussions on conntrack replication/syncronisation. There is an  
> ongoing (not yet finished) project implementing this kind of  
> function. There is a whole lot more involved than just "copying". 
 
   I'll look into google for "conntrack replication/syncronisation" and see what I can figure out, 
and also be waiting to see what you think about this considerations. 
   Thank's for your help, 
 
                        Daniel C. Azevedo 
