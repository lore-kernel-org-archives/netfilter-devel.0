From: Patrick McHardy <kaber@trash.net>
Subject: Re: childlevel's pom comment
Date: Thu, 04 Mar 2004 04:10:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40469E10.7080100@trash.net>
References: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: quadong@users.sourceforge.net
In-Reply-To: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Mathew,

I'm going to add your updated help-text. But I have doubts about
whether a new match is required at all. A connection can only have
a childlevel of one because only masters have helpers assigned to
them, although in theory the expect-function could register more
expectations. So you can basically match if a connection was
expected or not. The same can also be achieved by a trivial change
to the helper match, just allow zero-string length and use them
as a special value. This should also allow full userspace
compatibility. What do you think ?

Regards
Patrick


quadong@users.sourceforge.net wrote:
> Hi, I noticed that the childlevel patch currently has this to say about
> itself in patch-o-matic:
> 
> 	"This adds CONFIG_IP_NF_MATCH_CHILDLEVEL option, which be used to
> 	match the childlevel of a connection."
> 
> I know _I_ would be confused if I read this.  Could it be changed to the
> following?
> 
> 	This patch allows you to match on the childlevel of a connection.
> 	A master connection, such as the command stream of FTP, has a
> 	childlevel of zero, its first child, such as the data stream of
> 	FTP, has a childlevel of one.  Usage example:
> 
> 	iptables ... -m childlevel --level 1 ...
> 
> Thanks,
> matthew
