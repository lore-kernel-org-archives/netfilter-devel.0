From: Pablo Neira <pablo@eurodev.net>
Subject: Re: /proc/net/ip_conntrack
Date: Wed, 30 Jun 2004 15:37:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40E2C206.1070302@eurodev.net>
References: <20040629203549.M8283@linkexpress.com.br> <Pine.LNX.4.44.0406301236030.3767-100000@filer.marasystems.com> <20040630130806.M61849@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Daniel_Corr=EAa_de_Azevedo?=
 <nielca@linkexpress.com.br>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <20040630130806.M61849@linkexpress.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

Daniel Corrêa de Azevedo wrote:

>  I've just figured that out spending the hole night studing ip_conntrack source.
>

oh, welcome to the club. :-)

> Since I'm 
>really starting with advanced programming, it took me some time to figured out that 
>ip_conntrack matching works as a LKM (Loable Kernel Module) and that to write to the 
>/proc/net/ip_conntrack file, it should be a LKM too.
>  Tough, I still wonder if is there a solution to this problem.
>

sure, there is :-).

> I was thinking of LKMs and 
>wondering if it is possible to one write a LKM that interacts with the ip_conntrack LKM to 
>write entries to /proc/net/ip_conntrack? Or even write directly to it? 
>  
>

that's a misconception, you can't write to /proc/net/ip_conntrack. As 
Henrik pointed out, /proc/net/ip_conntrack is just an interface to give 
you a snapshot of the current state of the conntrack table. As this 
often get people confused, actually the replication of the conntrack is 
a problem a bit more complex than writing /proc/net/ip_conntrack.

Surely you can write a LKM which interacts with the ip_conntrack module, 
but you'll also need to export some symbols to do.

>   I've just loaded ip_conntrack LKM indirectly by inserting a statefull rule to iptables and 
>checkout what symbols it makes available.
>

check ip_conntrack_standalone.c to see exported symbols by the conntrack 
system.

>   Any way, what do you think about this? Does it sound like nonsense (I've just my first 
>contact with LKM...) or it maybe possible? 
>  
>

you should forget your thoughts about the /proc interface and start 
understanding some ip_conntrack internal to replicate the information to 
some backup's machines.

regards,
Pablo
