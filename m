From: Oskar Berggren <beo@sgs.o.se>
Subject: Re: Per-client NAT routing -- possible?
Date: Mon, 27 Mar 2006 08:37:54 +0200
Message-ID: <1143441474.13354.0.camel@otukt>
References: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jeremy Elson <jelson@gmail.com>
In-Reply-To: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>
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

On Wed, 2006-03-22 at 09:16 -0800, Jeremy Elson wrote:
> Hi,
> 
> I'm trying to set up a Linux box as a NATting router.  But here's the
> trick: my box's external interface is on a LAN that has a whole bunch
> of routers on it, any of which can be used to access the Internet. 
> I'm trying to figure out how to configure iptables so that the NAT box
> selects the router to use based on client IP address (i.e., the IP
> address on the inside interface).


It sounds like you need policy routing (multiple routing tables).

/Oskar

-- 
Oskar Berggren <beo@sgs.o.se>
