From: KOVACS Krisztian <hidden@balabit.hu>
Subject: RE: Redundant netfilter gateway
Date: Fri, 18 Jun 2004 11:56:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087552587.2422.19.camel@nienna.balabit>
References: <810BC538117E9F4E9BB152E0C100DF1F0F46CC@farmer.vikus.net>
	 <1087516560.1891.32.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Patrick Ahler <patrick@vikus.com>,
	Harald Welte <laforge@netfilter.org>, netfilter@lists.netfilter.org,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1087516560.1891.32.camel@anduril.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  Hi,

2004-06-18, p keltezéssel 01:56-kor Cedric Blancher ezt írta:
> Le ven 18/06/2004 à 01:50, Patrick Ahler a écrit :
> > I'm surprised there hasn't been more demand for a netfilter failover
> > module though, I know I would sleep better at night if there was. =)
> 
> There's definitly a strong demand. But there's not much offer yet...
> Things seems to be on the way.

  Netfilter failover is progressing silently... Harald has done a lot of
work based on my crappy proof-of-concept implementation, and things are
really getting to take off. This week I've spent a few days testing the
code, with somewhat mixed results. Certainly, there are a lot of
problems, It's not usable in its current form. However, I think that the
whole ct_sync code could be fixed and made into a _working_ piece of
long-awaited software in not more than a few weeks, if somebody with
enough knowledge _and_ free time would be able to help Harald. (I plan
to do so if I'll find the time.) Most of the code necessary for basic
synchronization is there, just contains bugs. So, come on dear Netfilter
hackers, we're not that far from providing a solution!

  Moreover, I think that a somewhat more open development model could
help. Currently, only the core ct_sync code can be found in the
Netfilter CVS (I don't know if it's up-to-date), the patchset needed to
be able to even compile the code is missing. (It took me a lot of time
just to gather the patches and make ct_sync compile.) There is not too
much information regarding the basic concepts of the proposed solution,
so publishing an easy-to-test package along with some instructions would
be an absolute must.

-- 
 Regards,
   Krisztian KOVACS
