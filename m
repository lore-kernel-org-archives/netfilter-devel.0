From: Simon Peter <simon.peter@gmx.de>
Subject: Benefits of Netfilter userspace extensions
Date: Mon, 5 Feb 2007 18:03:24 +0100
Message-ID: <20070205180324.4d682721.simon.peter@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

in general, is it beneficial to implement netfilter extensions
(especially packet mangling ones, using libnetfilter-queue) into
userland versus kernel?

Pros I can think of are:
- Ease of implemention, easier debugging, etc.
- More robust against bugs (only userspace program fails)

Of course there are cons, too:
- Slower
- Not as secure (userspace program might be easy to kill)

Did I miss anything?

Would you guys recommend to implement my packet mangling extension into
userspace, especially if I need to pull in a lot of information from
connection tracking?

Thanks,
Simon
