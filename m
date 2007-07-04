From: Patrick McHardy <kaber@trash.net>
Subject: Re: connmark and conntrack_ftp
Date: Wed, 04 Jul 2007 17:03:11 +0200
Message-ID: <468BB6AF.5050606@trash.net>
References: <468B88AF.3040707@orange-ftgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Elie Roux <elie.roux@orange-ftgroup.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468B88AF.3040707@orange-ftgroup.com>
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

Elie Roux wrote:
> Hello,
> 
> I'm working with Netfilter to build a system making QoS according to the
> mark of a connection. It works well with filters on the port and the ip,
> but I'd like to build something more efficient based on conntrack-*
> (ftp, irc, etc.). The problem is that I don't think it is possible right
> now. For example I have a ftp connection that have mark 2, and I'd like
> related connections to get mark 2 too.
> 
> Am I wrong when I say it is impossible ? Would it be possible to add it ?


Not sure which example you're referring to. RELATED connection inheirit
the mark from the master.
