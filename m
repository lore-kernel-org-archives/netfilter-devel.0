From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] patch-o-matic-ng patch
Date: Tue, 17 Feb 2004 17:20:59 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171653220.1545-100000@filer.marasystems.com>
References: <20040217152440.GP981@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040217152440.GP981@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Harald Welte wrote:

> Mh.  The idea of not having 'base', 'submitted', 'included' was mostly
> to avoid the ugly moving of files in the CVS tree, once they have been
> submitted.  This is fine for new features that get at some point
> included into the stock kernel.
> 
> One of the major differences of bugfixes is the ordering constraint.  In
> most cases, it's very important that they get applied in-order.  We
> could enforce this via 'Depends' and build a linear chain of fixes that
> each depend on each other.

My opinion:

It is good to have a repository of verified bugfixes, especially should a 
pom module depend on a prior bugfix. For me the bugfixes in pom has been a 
major releif for a long time and has worked well in maintaining the 
correct kernel version + pom.

What about this

Create a "patches" directory in pom-ng. This is a flat directory 
containing pending and submitted patches to the currently supported 
kernels.

Patches are numbered in the order produced. If a patch is later rediffed 
due to conflict give it a new number deleting the old. There is no need to 
reset the numbering, just keep increasing the number when adding new 
patches.

Each patch file has a header or info file telling
 * status of the patch (unfinished/pending/submitted)
 * for accepted submitted patches, which kernel revision the patch
accepted into to allow automatic pruning of already applied patches to
avoid patching conflicts and easier garbage collection to delete patches
outside the range of supported kernel revisions.
 * extensions required if depending on a recently submitted extension.

If the patch differs for 2.4 and 2.6 then name the patch (and info) file 
accordingly.

When an extension is accepted into mainline, update the info file of the
extension accordingly to record which kernel rev the extension was
accepted into. If the extension is then updated before it becomes obsolete
for pom update both the files of the extension and produce a patch file
with the update only. (or just produce a patch file)

Regards
Henrik
