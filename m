From: "John A. Sullivan III" <jsullivan@opensourcedevelopmentcorp.com>
Subject: Re: Altering destination ethernet device
Date: Fri, 25 Jun 2004 10:03:59 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088172238.30481.16.camel@localhost>
References: <20040625130142.54545.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040625130142.54545.qmail@web13907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-06-25 at 09:01, Scott MacKay wrote:
> Hello,
>    Sorry if this was asked before by someone, but is
> it possible to alter the destination interface for a
> packet?  In example, if I have a packet coming in eth0
> which could go out either eth1 or eth2, is there any
> way to force it to eth2?   I would be looking for a
> programming solution because the actual interface
> selected will be based on some critea which is
> programmed.  If it is possible, I would likely select
> the new interface in mangle/POSTROUTING unless it
> needed to be elsewhere.
<snip>
This may be better suited to iproute2.  To read the documentation, look
for a file named ip-cref.ps in your distribution.  There is a brief
slide show on using it in the training section at
http://iscs.sourceforge.net but it is directed towards using it with
FreeS/WAN.  I do not know what APIs are available. - John
-- 
Open Source Development Corporation
Financially sustainable open source development
http://www.opensourcedevelopmentcorp.com
