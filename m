From: Jean-Francois Dive <jef@linuxbe.org>
Subject: Re: netfilter / c++
Date: Mon, 24 Mar 2003 10:59:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030324095955.GK821@gardafou.assamite.eu.org>
References: <20030320184935.83289.qmail@web10708.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sdcan2019@yahoo.com
Content-Disposition: inline
In-Reply-To: <20030320184935.83289.qmail@web10708.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The actual design of the userland tool avoid it, so you'll have to use
exec + fork

JeF

On Thu, Mar 20, 2003 at 10:49:35AM -0800, sdcan2019@yahoo.com wrote:
> Hi there netfilter hackers ,
> 
> 
> i am working on a project (C++) and i have to use some
> of the iptables commands in my programme; are there
> any 
> interface to netfilter for C on linux ? 
> 
> 
> Thanks for the time reading and answering ,
> 
> Keep up the good work !
> 
> Suha Demir CAN
> 
> __________________________________________________
> Do you Yahoo!?
> Yahoo! Platinum - Watch CBS' NCAA March Madness, live on your desktop!
> http://platinum.yahoo.com

-- 

-> Jean-Francois Dive
--> jef@linuxbe.org

  There is no such thing as randomness.  Only order of infinite
  complexity. - Marquis de LaPlace - deterministic Principles - 
