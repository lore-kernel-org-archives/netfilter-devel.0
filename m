From: Eric Leblond <eric@inl.fr>
Subject: Re: Logging ownership
Date: Fri, 19 Nov 2004 14:08:29 +0100
Message-ID: <1100869711.3610.24.camel@coati>
References: <20041118201628.GA10213@donard.lan.campbell-multimedia.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20041118201628.GA10213@donard.lan.campbell-multimedia.co.uk>
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

On Thu, 2004-11-18 at 20:16 +0000, Paul Campbell wrote:

> Basically what I am after, and there might be an easier way...  Is to trigger 
> a userspace alert when an unknown program attempts to form a new connection.
> Personal firewall style for Desktops.

NuFW (http://www.nufw.org) may be a solution, is is an authenticated
firewalling solution. I mean it is able to filter a whole network with
acls of the type :
John has access to external imap server if he uses thunderbird on XP SP2 
or even better
John has access to external imap server if he uses evolution on Linux ;-)

There's no alert in case of problem but NuFW is able to log dropped
packet in a SQL database. Applications logging in case of failure has
just been added at my TODO list.

> I'm assuming the packet -> program -> user relationship only exists within the
> kernel.

There's socket-> program -> user relationship

BR,
-- 
Eric Leblond <eric@inl.fr>
INL
