From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Tue, 28 Jun 2005 14:57:40 -0700 (PDT)
Message-ID: <20050628.145740.54199384.davem@davemloft.net>
References: <20050628114330.GA16681@sunbeam.de.gnumonks.org>
	<20050628.124640.57169557.davem@davemloft.net>
	<20050628212811.GE19036@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050628212811.GE19036@sunbeam.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 28 Jun 2005 23:28:11 +0200

> really sorry, once again.  I need to practise more with git/cogito :(

No problem.  Do this:

mkdir linux-2.6
cd linux-2.6
rsync -avz rsync://rsync.kernel.org/pub/scm/linux/git/torvalds/linux-2.6.git/ .git
cp .git/HEAD .git/ORIG_HEAD
git-read-tree $(cat .git/HEAD)
git-checkout-cache -a
git-update-cache --refresh
/* edit files */
git diff HEAD >diff
/* edit 'diff' adding changelog and signed off messages */
cat diff | mail davem@davemloft.net

:-)

I wouldn't bother with my net-2.6.git tree, it's a throwaway tree I
use just to push changes to Linus.  It is rarely much out of sync with
his tree, as he usually pulls from me within 24 hours of when I ask
him to.

As a matter of personal taste, I think using the raw GIT tools is
easier.

And Jeff Garzik posted a really nice HOWTO on linux-kernel last week.

Finally, here are three scripts I use.  The latter two require that
you keep your .git/ORIG_HEAD uptodate, but other than that it should
just work.

The first one I call 'apply'.  It's how I add a patch to my tree.
It takes 4 arguments:

1) Patch author name, ie. "David S. Miller"
2) Patch author email, ie. "davem@davemloft.net"
3) Patch file name, ie. whatever.diff
4) Changelog message file name, ie. whatever.msg

The second one is called 'git-mklog' which generates a log file
of all changes from ORIG_HEAD to HEAD.  First, it outputs the full
diffstate, then for each change you get a changelog message and
a diffstat.  This is handy for pushing GIT trees to me or other
developers.

The third one is called 'git-mkpatches'.  It creates a directory
called 'patches/' and dumps each change from ORIG_HEAD to HEAD
into consequetively numbered patch files, ie. patches/1.diff,
patches/2.diff, patches/3.diff, etc.  Each patch file is prepended
with a changelog entry.  I use this when I want to clone up a new
fresh tree to stick the patches into so that the history looks more
clean.  Or, sometimes, you notice a mistake in some patch in the
middle of the ones you've added to your tree and rebuilding the
tree is the quickest way to fix that up.

--------------------
#!/bin/sh
#
# apply USER_NAME USER_EMAIL PATCH_FILE MSG_FILE
#

PATCHFILE=${3}
MSG_FILE=${4}

FILES="cf"

GIT_COMMITTER_NAME="David S. Miller"
GIT_COMMITTER_EMAIL=davem@davemloft.net
export GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

GIT_AUTHOR_NAME=${1}
GIT_AUTHOR_EMAIL=${2}
export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL

# Make sure patch file exists.
if [ ! -f ${3} ]; then
  echo "apply: patch file does not exist, please fix";
  exit 1;
fi

# Make sure message file exists.
if [ ! -f ${4} ]; then
  echo "apply: message file does not exist, please fix";
  exit 1;
fi

mkcf $PATCHFILE >$FILES

git-check-files $(cat $FILES) || exit 1
git-checkout-cache -q $(cat $FILES) || exit 1
patch -u --no-backup-if-mismatch -f -p1 --fuzz=0 --input=$PATCHFILE || exit 1
git-update-cache --add --remove $(cat $FILES) || exit 1
tree=$(git-write-tree) || exit 1
echo Wrote tree $tree
commit=$(git-commit-tree $tree -p $(cat .git/HEAD) < $MSG_FILE) || exit 1
echo Committed: $commit
echo $commit > .git/HEAD
--------------------
#/bin/sh

git-rev-list HEAD ^ORIG_HEAD | tac >.commit-list
cat .commit-list | git-diff-tree --stdin -p | diffstat -p1 
echo ''
for i in $(cat .commit-list)
do
    git-diff-tree -s -v ${i}
    git-diff-tree -p ${i} | diffstat -p1
    echo ''
done

rm -f .commit-list
--------------------
#/bin/sh

mkdir patches/

count="1"
for i in $(git-rev-list HEAD ^ORIG_HEAD | tac)
do
    git-diff-tree --pretty -p ${i} > patches/$count.diff
    count=$(($count + 1))
done
