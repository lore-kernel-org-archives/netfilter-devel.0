From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: RE: ICMP unreachable (DF) does not report the NATed IP
Date: 28 Apr 2003 19:50:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051552224.5946.239.camel@tux.rsn.bth.se>
References: <4F9AFAF72B246745B6847C7EECD8FF6901D17A81@EXCHANGE1.charite.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>
In-Reply-To: <4F9AFAF72B246745B6847C7EECD8FF6901D17A81@EXCHANGE1.charite.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-04-28 at 17:57, Hillmann, Oliver wrote:

> I have been subcribed to netfilter-devel, but first wanted to send it to a more general list before bothering the developers with this...
> 
> As soon as I find some time, I will be looking into this and try to come up with a NAT helper module... Any comments and suggestions are welcome!

That's the wrong way to do it, fix the cause of the problem. It's the
code in icmp_reply_translation() in ip_nat_core.c

I've havn't given it much thought yet.

Also look at the submitted/11_inner-icmp-translation-fix.patch patch in
patch-o-matic as it modifies this function.

-- 
/Martin
