From: "Christoph Lenggenhager" <clenggenhager@gmail.com>
Subject: State of the conntrack match
Date: Mon, 30 Apr 2007 15:31:20 +0200
Message-ID: <a475e7310704300631m73f8a14yfad2afb10b041592@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi

I would like to use a conntrack match (i.e. -m conntrack --ctorigdst
...), but I miss the ability to filter for the original source and
destination ports.

When going through the archives of netfilter-devel, I see that the
conntrack match has originally been developed by Marc Boucher.
Back in 2002, Henrik Norstr=F6m wrote a patch to it that would precisely
fit my needs.
(cf. http://lists.netfilter.org/pipermail/netfilter-devel/2002-July/008382.=
html)
Unfortunately, this effort seems to have died with the advise from
Harald Welte to contact Marc Boucher directly.

My questions are now:
- What is the status of the conntrack match? Is it just "there" to be
used, but nobody ever wants to touch it again?
- Would it be appreciated to take up Henrik's (old) ideas? Is there a
chance to take such changes into the main tree? Since I do not know
better: Is this a "good" idea or does it make you scream and run away?

Well, this is more a user-related question:
- Assuming conntrack match is too old and out-dated, is there an
alternative way to filter based on the original data (addresses and
ports) of a packet?

Thanks for any reply.

Kind regards,
christoph
