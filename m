From: Flavio Pescuma <flavio@marasystems.com>
Subject: Re: how to clear the conntrack table!
Date: 27 Jun 2003 11:28:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056706091.4078.26.camel@alba>
References: <006301c3630d$7c163260$5b01aa0a@nightmare>
	 <20030823210837.GE6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Decoy <yangzehui@boco.com.cn>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030823210837.GE6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

You could look into using the patch I send some day ago.  the you could
set all connection to unconfirmed, and then set you rule set so that al
unconfirmed packets pass the rule set


/flavio

On Sat, 2003-08-23 at 23:08, Harald Welte wrote:
> On Fri, Aug 15, 2003 at 05:13:05PM +0800, Decoy wrote:
> > Hi!
> > 
> > how can I clear the conntrack table?!
> 
> unfortunately there is currently no other way than to unload and reload the
> ip_conntrack module :(
> 
> > Thanks very much!
> > dec0y
