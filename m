From: Max Kellermann <max@duempel.org>
Subject: Re: Problem: cannot apply H.323 conntrack patch on Linux 2.6.11
Date: Tue, 8 Mar 2005 14:42:03 +0100
Message-ID: <20050308134203.GA16137@roonstrasse.net>
References: <A4ED24A7CF46224E9246EBF1E71B0B90015CE67A@mtlmail.eicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
To: Paul Gallant <Paul.Gallant@eicon.com>
Content-Disposition: inline
In-Reply-To: <A4ED24A7CF46224E9246EBF1E71B0B90015CE67A@mtlmail.eicon.com>
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

On 2005/03/08 14:40, Paul Gallant <Paul.Gallant@eicon.com> wrote:
[...]
> Then tried to apply Patch-o-Matic-ng-20050306 to add H.323 conntrack.
> 
> The patch does not apply... (It is specified that it requires: linux-2.6 >=
> 2.6.11)
> 
> It seems that ip_conntrack.h file structure changed and that there is no
> more "insert conntrack helper private data (expect) here" section anymore.
> 
> What should I do to resolve this issue?

There is already a patch for that. Please check out the "linux 2.6.11"
branch from the patch-o-matic repository, it contains my 2.6.11
patches.

btw. the subversion repository on svn.netfilter.org is still broken -
"Could not open the requested SVN filesystem". Could somebody fix that
please?

Max
