From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Netfilter based application : any advice ?
Date: Tue, 16 Mar 2004 11:26:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4056D65E.6080001@eurodev.net>
References: <200403141930.29602.alchemyx@uznam.net.pl> <1079300670.3068.182659007@webmail.messagingengine.com> <40556E79.50608@eurodev.net> <1079370118.16263.182707172@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Saber zrelli <saber_z@fastmail.fm>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <1079370118.16263.182707172@webmail.messagingengine.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

Saber zrelli wrote:

>hi ,
>so if i well understood  ; 
>Netfilter doesn't offer packet injection , and i have to use libnet .
>  
>
you can inject packets in kernel space, but I recommend you working from
user space.

>then , the other point :
>I would like to capture in link level , 
>Netfilter can aceess MAC adresses 
>
if you want to work in link layer, have a look at ebtables.

http://ebtables.sourceforge.net/

regards,
Pablo
