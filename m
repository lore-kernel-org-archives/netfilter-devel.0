From: Patrick McHardy <kaber@trash.net>
Subject: Re: stat module
Date: Tue, 11 Nov 2003 13:27:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FB0D5CD.6060401@trash.net>
References: <1068547747.1719.114.camel@jazz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juha Heljoranta <juha.heljoranta@evitech.fi>
In-Reply-To: <1068547747.1719.114.camel@jazz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Juha Heljoranta wrote:

>Hi, 
>
>I was thinking about to write a module to match outbound packets against
>stat (file of filesystem status) information. One might find device and
>inode information usefull.
>
>Usage might be something like
>$ iptables -A OUTPUT -m stat --device 303 --inode 341166 -j ACCEPT
>
>Anyway, I thought to ask if you have any suggestions, thoughts,
>opinions, etc. about this. I might find them helpfull :)
>  
>
Not sure what you want to match here, is it the inode of the
executable that created the packet ? If so, have a look at
the owner match.


>I have about 400 hours to spend on this. So how does it sound? 
>  
>
I wish I had 400 hours .. ;)

Best regards,
Patrick
