From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Sun, 23 Jun 2002 11:14:45 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <008101c21a96$6feec210$0489cb8a@etbx180>
References: <20020621132640.2C326472B@lists.samba.org> <15635.25545.469973.950625@isis.cs3-inc.com>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Don Cohen" <don-nf@isis.cs3-inc.com>,
	<netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> > I'm doing some tcp benches on a netfilter enabled box and noticed
>  > huge and surprising perf decrease when loading iptable_nat module. 
> Rather similar to the results I posted about a week ago.

yes, i noticed it after my tests, sorry for this new thread. ;o)

> 
>  > - Another (old) question: why are conntrack or nat active when there are
>  > no rules configured (using them or not)? 
> I noticed this too.  After a test using conntrack the next test
> without "using" conntrack would perfom poorly unless I did rmmod.

yes, minor issue if documented... but serious risk.

> 
>  > Since in my test, each connection is ephemeral (<10ms) ...
> When all works correctly, the end of each connection should be noticed
> by conntrack and the connection removed from the table, right?

yep

> In which case the table should never get very full.

ideally yes, but from the conntrack machine perspective, the rest of
the world should not be considered reliable... and in fact it is not.
So, timouts should be reviewed, especially if we know that the average
tcp connection duration on the www is about 20 seconds. 
Generic timeouts are not suited to real world traffic.

> So I'm guessing that large number of entries in conntrack table is
> evidence that packets are being lost.  

not only: a crashed endpoint breaking the tcp sequence causes also
garbage entries in conntrack (known issue).

> In particular, if the syn
> packet arrives but is never forwarded, you get one of those conntrack
> entries where conntrack thinks (incorrectly) the syn has been
> forwarded so it's waiting for the reply.  Ideally the entry should
> not be added to the table until the packet goes out.

??? or is served locally ???

> 
> Just wondering, how did you measure cpu load?
> 

procinfo -n10 ; [d] for showing differences, which in fact, computes
                   the differences of cumulated cpu time (got from 
                   /proc/stat) on the given period: (tsys1-tsys0)/T
                   (I was too lazy to write a script...)

--

Maybe my mail was not clear... I've been surprised by 2 issues:
1) conntrack timeout garbages (which was addressed by you mail)
2) nat performance killing: I really don't understand it, especially
   when there's no rule active on it, and thus no translation active.

I can admit the overhead of conntrack because of the number of
entries and criteria it has to manage, but this one can be 
dimensionned and understood. 
But what about NAT??? In my opinion, the NAT overhead should only
be a delta against the conntrack overhead. But what I noticed is 
an overhead as big as the conntrack overhead! why?

_______________________________________________________________________
-jmhe-               He who expects nothing shall never be disappointed
