From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Re: problem with iplimit
Date: Thu, 31 Oct 2002 12:01:08 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <NDBBKOCLFLKJBBJIHCODAEMBCDAA.sumit@elitecore.com>
References: <20021030090702.18873.97698.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <romp@siil.net>, <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20021030090702.18873.97698.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
	Just try with solution posted on following link
http://lists.netfilter.org/pipermail/netfilter/2002-January/030405.html
-- Sumit

> From: Harald Welte <laforge@gnumonks.org>
> 
> On Sat, Oct 26, 2002 at 11:26:53AM +0300, Romp wrote:
> > > The problem appears every time I try to use this module.
> > > if I set --limit-above to 2 and try to open third connection, 
> system wi=
> ll drop it (ok).
> > > But if I try to open this connection again (while previous 2 
> connection=
> s are still active), system will accept it (!).
> > > Since, almost every connection will be accepted (!).
> > > Note that if I close all connections, and try to make 
> described test ag=
> ain, all will happen again.
> > the problem (and fix) is also described at
> > 
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-May/007818.html
> 
> interesting. I will add this issue to the TODO list.
> 
> > unfortunately, the patch provided does not solve the problem 
> (at least for
> > me)
> 
> even more interesting...
> 
> I have some higher-priority stuff to do right now, but I will try to get
> back to this issue ASAP.
> 
> > romp
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org
