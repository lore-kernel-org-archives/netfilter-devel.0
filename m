From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: netfilter
Date: Thu, 27 May 2004 04:11:36 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085645478.10045.10.camel@localhost>
References: <20040526021817.16087.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sokhan heng <sokhan2001@yahoo.com>
In-Reply-To: <20040526021817.16087.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-05-25 at 22:18, sokhan heng wrote:
> Hi there
> 
> I wonder if I could ask you one question please about
> netfilter? I wonder if it can be used to prioritise
> traffic, by that I mean when two packets are sent to
> the same destination, one can be delayed to let the
> other packet pass first. if it can, can you tell me
> what topic should I look for to get how to do that
> please?
> 
> Yours sincerely
> 
> Sokhan H 
<snip>
I do not believe that is a netfilter function.  You could take a look at
iproute2.  The documentation is frequently found in a file named
ip-cref.ps
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net 
