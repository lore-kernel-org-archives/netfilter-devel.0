From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] man page: alphabetize extensions + add physdev entry
Date: Tue, 18 Feb 2003 17:47:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218164739.GF445@eychenne.org>
References: <200302132039.58656.bdschuym@pandora.be> <20030214072944.GI14794@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20030214072944.GI14794@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 14, 2003 at 08:29:45AM +0100, Harald Welte wrote:

> > here's the patch.

> thanks, applied.  Can I ask you to do the same for ip6tables.8 to be
> consistent?  Thanks.

Ok, I'll let Bart do the job.

> What also is on my TODO list for some time:  Put manpage sections for
> all recently-added-to-mainstream-kernel matches+targets.  I think the
> manpage hasn't been synced with the by-default available matches/targets
> for quite some time.

Oh, really?
It seems to me that my last patch added the missing matches and
targets, and that none has been added since (although I remember
having posted a request on netfilter-devel about the possible
inclusion of NETMAP in mainstream kernel and received no answer...).

I just checked my /usr/src/linux-2.4.20/net/ipv4/netfilter and I saw
no match or target available in mainstream kernel (this is what you
mean by "default", am I right?) which is missing in the current
iptables manpage...

However, some new options in existing netfilter modules may well be
missing (I didn't check), if the person who added them didn't provide
any manpage update in his patch, which is of course a very bad thing
(not) to do.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
