From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 30 Apr 2003 00:38:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051655925.8201.59.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304300014090.2169-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304300014090.2169-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 00:15, Jozsef Kadlecsik wrote:
> On Sun, 27 Apr 2003, Rolf Fokkens wrote:
> 
> > Well, after all this panic and calming down something constructive:
> >
> > Should a lock per contrack entry be considered? This increases the
> > concurrency for different connections anyhow.
> 
> Yep, I'm working on such a patch.

Care to describe how you are going to build it?

-- 
/Martin
