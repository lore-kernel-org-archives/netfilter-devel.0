From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables] NFLOG-testx is not executable
Date: Wed, 05 Sep 2007 01:17:45 +0200
Message-ID: <46DDE799.1010003@trash.net>
References: <1188934668.29347.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1188934668.29347.11.camel@localhost>
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

Eric Leblond wrote:
> The test for NFLOG is not executable. This prevents NFLOG from building.
> 
> A commiter should run the following command to change executable
> property in subversion tree:
> svn propset svn:executable "on" extensions/.NFLOG-testx


I also noticed this, I think I'm just going to add the header
files and change it to build the extension unconditional (for all
other extensions as well, since we've removed all external extension
the conditional building doesn't make any sense anymore).
