From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: pending/69_amanda-helpers.patch does not apply to 2.4.22?
Date: Sun, 12 Oct 2003 01:00:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1065913241.29186.4.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0310112315200.14720-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310112315200.14720-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-10-11 at 23:22, Henrik Nordstrom wrote:
> After a recent CVS update of my pom tree the pending patch set no longer 
> applies to 2.4.22, failing in pending/69_amanda-helpers.patch

I havn't had time to do my usual checking to see if everything applies.
I usually catch these things fairly quickly.

After a very quick look, I'd say it looks like a conflict between
61-remove-memsets.patch and 69_amanda-helpers.patch
Both by Patrick.

Patrick, do you think you could fix it up?

-- 
/Martin
