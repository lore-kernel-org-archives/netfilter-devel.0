From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: iptables source help
Date: Mon, 08 Mar 2004 16:25:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404C823C.5020304@netlab.hut.fi>
References: <404C7DBB.3000508@aiqa.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Depending on their architecture, machines do not read data in the same 
order (i.e. when reading a byte, do you start with the most or less 
significant bit?).
The function ntohl (for long words or ntohs for short words) will always 
translate the data so that the host can read it in the right order.
The function htonl (or htons) translate the data o that it is 
transmitted in the right order on the wire.

    Emmanuel

Ozgur AKAN wrote:

> Why is ntohl() is used. "network byte order to host byte order" what 
> does this mean?
>
> thanks,
> Ozgur AKAN
>
