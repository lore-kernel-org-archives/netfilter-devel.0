From: Eicke Friedrich <tady@gmx.net>
Subject: Re: Feasability of Protocol Filtering
Date: Thu, 24 Apr 2003 22:31:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA849BE.7080205@gmx.net>
References: <Pine.LNX.4.44+maildir.0304231452150.9967-100000@woozle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44+maildir.0304231452150.9967-100000@woozle.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matt Skidmore wrote:
> the downside to this is, say you want to reject SSH traffic. you
> issue the command to reject it based on protocol. if there is a
> connection already in progress it probably wouldnt get it unless
> there are some telltale signs in the data packets, but since you 
> can at least identify the initial connection packets you could at
> least stop additional connections.
Yes, you are absolute right. But i don't see a way to change this. For
p2p the already
established connections are not worth any effort. At some point the
file is completly
transfered (kazaa) or the transfered segment has to be acknowlegded
(edk). My match will
find this ack and treat the following packets as p2p-traffic.

> I would be interested in seeing what you have so far. as for CPU
> and RAM concerns, I thought about this a bit myself. it could also
> intoduce latency as well.
I can send you the source-code if you want to.

Regards,
Eicke.
