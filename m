From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: TCP window tracking has bad side effects
Date: Thu, 9 Dec 2004 17:26:56 +0100
Message-ID: <20041209162656.GA9569@suse.de>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
	<20041201153903.GA16807@suse.de>
	<Pine.LNX.4.58.0412030942320.30157@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412060934050.5880@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412060934050.5880@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Fri, 3 Dec 2004, Jozsef Kadlecsik wrote:
> 
> > On Wed, 1 Dec 2004, Ludwig Nussel wrote:
> >
> > > My description probably wasn't unambiguous. The client has the
> > > packetfilter, crashes and reboots.
> >
> > I see - that case was not handled in the code. Please try the patch below
> > and report the result.
> 
> Oh, I'm sorry that was an incomplete patch. This is the fixed code, please
> give it a try.

Seems to work. The client machine no longer drops the packet and
properly sends RST.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/
