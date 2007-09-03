From: Philip Craig <philipc@snapgear.com>
Subject: netfilter support in libnl
Date: Mon, 03 Sep 2007 15:09:42 +1000
Message-ID: <46DB9716.1020400@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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

There have been comments in the past on this list about using libnl
for the netfilter netlink support, and since I would like to use a
common library api for all the netlink interfaces, I decided to give
it a go.  These patches are the result of that.

Any comments welcome, particularly about whether this is still
something that is desired.

Some notes about the patches:
- only tested on an ARM platform
- only conntrack and log implemented (not queue)
- only dumping and monitoring implemented (no modifications)
- monitoring ct/log events requires copying all the netlink message
data into another object, which seems a bit inefficient
- I defined a cache to monitor log messages, so that it can find the
parser automatically, but not sure that caching log events makes sense
- I've added 'test' operations for some ct/log fields.  None of the
other objects in libnl have these, but I think they are needed.
