From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: target for modifying conntrack timeout value
Date: Tue, 7 Dec 2004 09:55:56 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412070951290.30464@filer.marasystems.com>
References: <EINSTEIN93MgPPf3L9B00006a59@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEIN93MgPPf3L9B00006a59@einstein.systemmetrics.com>
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

On Mon, 6 Dec 2004, Richard wrote:

> Ok, I got the latest svn. However I have trouble to get a diff between it
> and my working copy. "svn diff" only diffs the existing files and does
> generate a patch for new files.

Have you "svn add":ed them?

> Anyway, I attached this tar.gz file which is extracted into netfilter
> directory. Then run "patch -p0 Makefile.diff".

You don't need to patch the Makefile. Just add a .<yourname>-test file 
(see existing ones as examples)

And you can place all the files in pom. Just move your iptables directory 
into your pom directory, next to the linux directory.

Regards
Henrik
