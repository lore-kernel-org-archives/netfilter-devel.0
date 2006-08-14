From: Patrick McHardy <kaber@trash.net>
Subject: priv_data patch
Date: Mon, 14 Aug 2006 15:34:05 +0200
Message-ID: <44E07BCD.8030206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
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

I'm afraid I have some bad news ..

While merging the priv_data patch I noticed an oversight. Currently,
when modifying the ruleset, all modules dump their entire state
(user configuration + internal state kept in the same structure)
to userspace, which will return it to the kernel. That means for
example that the limit match will not loose its current state when
modifying other rules. When we move the state out of the data shared
with userspace this can't be done anymore, so each modification to
the table will cause all modules to loose their current state, even
if they we're not directly affected by the change. We can't break
this behaviour, so this limits potential users of the priv_data stuff
to things like hashlimit or recent, which do a lookup of state stored
completely external from the ruleset (and could use it to cache the
lookup result). I don't think that this is worth it, we probably need
to wait until we have a better userspace interface before we can do
something like this ..
