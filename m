From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 01 May 2003 12:01:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051783259.8212.256.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
	 <20030501015802.2CB152C2D9@lists.samba.org>
	 <20030501054830.GA15143@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030501054830.GA15143@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-01 at 07:48, Patrick Schaaf wrote:

> As an aside, and independant of the key sorting/flipping,
> we could eliminate completely the info struct array we
> now have in each conntrack. Interested? Then I'll write
> how I envision that.

Please do.

> Finally, regarding the locking, I would like to mention
> the memory conservative "sectored locks" approach.
> Break the hash table into sectors, about N*NR_CPU
> of them. Use one rwlock per sector.  Given an equally
> distributing hash function, the probability that two
> of our NR_CPU cpus will lock the same sector at the
> same time, becomes small with growing N, fast.
> 
> This way, a lot less locks than with one-lock-per-chain
> or one-lock-per-conntrack can be used, without compromising
> concurrency too much.

I like this, if you have 512k buckets you don't want 512k locks if it's
a 2way SMP machine.

-- 
/Martin
