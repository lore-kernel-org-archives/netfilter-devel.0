From: Henrik Nordstrom <hno@marasystems.com>
Subject: [patch pomng] missing .ladd files etc
Date: Sat, 28 Feb 2004 23:57:29 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402282354370.12487-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0402281935160.10963-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0402281935160.10963-200000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Looks like this message got stuck somewhere, maybe due to the relatively
large patch attachment.

Trying one more time with the attachment saved at 
<url:http://marasystems.com/download/netfilter/patch-o-matic-ng.patch>


On Sat, 28 Feb 2004, Henrik Nordstrom wrote:

> A closer inspection revealed that the ipv6 stuff was left behind.
> 
> The attached patch and script is updated to take ipv6 patches into 
> account, and replaces the version posted earlier today.

There was a little more to it than just running the script as pom-ng has 
newer copies of a few patches than pom and a few other minor things, but 
attached is a large patch which adds a lot of missing .ladd files to 
pom-ng found by having pom-ng rebuilt from pom and then recovering the 
newer versions.

The patch also includes a resync of the HL patch to match what is in pom
(use HL everywhere). The directory is still called HOPLIMIT.

The merge of ipv4 and ipv6 patches in one directory is kept as it is.

Regards
Henrik
