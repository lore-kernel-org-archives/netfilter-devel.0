From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 02 May 2003 14:30:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051878601.3825.6.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0305021411200.7105-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0305021411200.7105-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-05-02 at 14:18, Jozsef Kadlecsik wrote:

> I'm working on an updated raw patch (+ splitted up to internal logging +
> raw patches) and an updated and further tuned tcp window tracking patch (+
> splitted up to proc + tcp window tracking patches). It'll take probably
> one more week and then I'll submit a patch on a better hash function for
> conntrack.

While on the subject of the raw patch, please don't forget to add the
fix for the NFC_ clash I added to cvs a little while ago. The
userspace/raw.patch depends on pending/27_include-nfc-order.patch


Can I get a feature-request? :)
-j NOTRACK --only-search

that would be nice, search the hashtables but don't allocate new entries
if not found and if not found mark as UNTRACKED. It will do the same as
dropping --state NEW later but avoids the alloc and init.

-- 
/Martin
