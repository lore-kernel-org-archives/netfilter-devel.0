From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH 2.4] nf-log update against latest 2.4-git
Date: Sun, 30 Oct 2005 12:18:52 +0100
Message-ID: <4364AC1C.8000907@drugphish.ch>
References: <4360F91B.1010509@tac.ch>
	<20051030094916.GC4479@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Roberto Nibali <ratz@tac.ch>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20051030094916.GC4479@sunbeam.de.gnumonks.org>
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

Hi Harald,

Summary in case you're short in time: I completely acknowledge and agree
with your decision, but would still like to discuss a few issues
regarding netfilter development in person.

>> While updating my patchset I realised that the nf-log patch needed for
>> the tcp window tracking feature does not properly apply anymore as-is.
>>
>> So here is an updated version against the latest 2.4-git which should
>> work also when 2.4.32 is released. It's compile tested.
> 
> eek, a 2.4.x user ;)

We could go into a long argument as to why 2.6.x is not ready for use
with our business cases, foremost it being too unstable API wise, along
with a rather large list of things just not working 100% correctly yet.

But I think we should happily spare this list with this ;). I'd be
inclined to state that there are far more 2.4.x nodes in productive
environments (accounting for productivity per time unit, or adding to
the revenue) than productive nodes in 2.6.x.

I'll be in Berlin between 27. Dec 2005, 22:25 and 30. Dec 2006 06:45.
I'd be happy to have a meeting with you to discuss some netfilter
issues, preferably in a quiet place at the CCC. Please contact me
off-list if you're interested and have the time.

>> Please consider applying,
> 
> mh, we've recently decided not to officially support any other kernels
> than the latest released stable kernel (which is 2.6.14 now).

I acknowledge that the netfilter core team has always been a bit short
in supply of man-power, but always with excellent brain-power. It
strikes me as particularly odd that the core netfilter code which should
have been stable and mostly bug free has needed so much attention in the
last couple of years (especially the 2.4.x kernel), depriving it
somewhat of technical invention (opposed to now, where great effort is
put into netlink related technology integration).

Obviously your team does not have the willingness nor time to further
pursue in addressing 2.4.x kernel needs, which I understand. However I
still hope to get some support in debugging my issues in the 2.4.x
series regarding netfilter.

> I know, we tried to be differernt for a long time, but most projects
> don't support 'new feature' patches for old kernel versions.

Indeed, in IPVS we also do not have backported several features from
2.6.x to 2.4.x although being available since 2.2.x series. This of
course adds to the time needed to maintain two adjacent kernel trees,
and in our case even yielded two user space branches ;(.

> Soon we will be able have 'remote references' from patch-o-matic, so
> people can run their own repositories (like they can do now with apt,
> for example).

I will and must (as a company also in selling firewall services we a
bound by the GPL) always put up my recent kernel patches, so nothing
will be lost.

I quit my whining now :). Thanks for the heads-up and keep up the
excellent work on state synchronisation, {ct,nf}netlink and x_tables.

Best regards,
Roberto Nibali, ratz
-- 
echo
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
