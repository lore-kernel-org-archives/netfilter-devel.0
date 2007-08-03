From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: conntrack: UDP NAT vs. VPN tunnel
Date: Fri, 3 Aug 2007 16:13:43 +0200
Message-ID: <200708031613.43721.thomas.jarosch@intra2net.com>
References: <200708021817.38209.thomas.jarosch@intra2net.com>
	<46B27601.8000505@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B27601.8000505@snapgear.com>
Content-Disposition: inline
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

Philip,

On Friday, 3. August 2007, Philip Craig wrote:
> > I've now searched for possible solutions. I could write a program that
> > gets called after the VPN tunnel is reestablished and deletes all UDP NAT
> > conntracks matching the IPs of the VPN tunnel. This is rather complex,
> > but possible. Maybe there is a more simple solution?
>
> Add a filter rule that drops packets with a VPN destination that are
> not going over the VPN.  Then the conntrack is never created until
> the VPN is up.  This is good for security too, so that you aren't
> leaking private data.

Thanks, that's the perfect and simplest solution for the problem!
(read: Doh!) I was stuck with the idea to write some code, that's why
I posted it to -devel. It's always good to ask for a second opinion :-)

Have a nice weekend,
Thomas
