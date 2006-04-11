From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Tue, 11 Apr 2006 17:09:31 +0100
Message-ID: <443BD4BB.7090806@ufomechanic.net>
References: <Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>	<43F4DBDF.9010008@trash.net>	<442B9765.2020105@ufomechanic.net>	<442C81A6.3040501@trash.net>	<Pine.LNX.4.58.0603312026030.9154@blackhole.kfki.hu>	<442D78A8.4050300@trash.net>	<20060401193138.GG11031@sunbeam.de.gnumonks.org>
	<4434F53A.2030302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4434F53A.2030302@trash.net>
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

Patrick McHardy wrote:
> Harald Welte wrote:
> 
>>So if there's now a majority of people who want to delete the ID: Go for
>>it :)
> 
> 
> Found the patch again. What it does is:
> 
> - note entry of next conntrack to be dumped and keep a reference to it
> - when continuing, look for the conntrack and continue at it if its
>   still there
> - if not, dump the entire bucket again
> 
> In theory we could end up in an endless loop if the conntrack entry
> we're keeping the reference to is deleted everytime we want to
> continue dumping. 

Why not defer the ip_conntrack_put until after ctnetlink_fill_info, 
would that avoid the problem altogether?

It's no longer the entry of the next conntrack but the entry of the last 
conntrack by the time it gets deleted then...? Or have I misunderstood 
the way in which the loop would occur?

Sam
