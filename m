From: "Saber zrelli" <saber_z@fastmail.fm>
Subject: Re: Netfilter based application : any advice ?
Date: Tue, 16 Mar 2004 02:01:58 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079370118.16263.182707172@webmail.messagingengine.com>
References: <200403141930.29602.alchemyx@uznam.net.pl> <1079300670.3068.182659007@webmail.messagingengine.com> <40556E79.50608@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: "Pablo Neira" <pablo@eurodev.net>,
	"Netfilter Community" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40556E79.50608@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi ,
so if i well understood  ; 
Netfilter doesn't offer packet injection , and i have to use libnet .
then , the other point :
I would like to capture in link level , 
Netfilter can aceess MAC adresses and other Ethernet parameters cause it
support it ,
but if for example i'm using wireless network and want to filter wireless
packets , does ethernet offer 802.11 specific methods , or is there a
standard link layer methods that supports all kind of protocols ?

thanks for clarifications.



On Mon, 15 Mar 2004 09:51:05 +0100, "Pablo Neira" <pablo@eurodev.net>
said:
> Hi,
> 
> Saber zrelli wrote:
> 
> >- Is it possible to send packets with Netfilter or not? ( if not i guess
> >using libnet will resolve the pb but better to have  
> >  every thing based on the same infrastructure)
> >  
> >
> 
> If you can do that in user space, have a look at libnet.You can forge
> packets in inject them.
> 
> 
> >- I would like to have the tool work with wireless protocol , does
> >Netfilter support non Ethernet proto and 802.11 particulary?
> >  
> >
> 
> This is transparent to netfilter since it's in OSI layer 3/4.
> 
> regards,
> Pablo
> 
-- 
  Saber Zrelli
  kanazawa university international house 
  kakuma-machi , kanazawa , Ishikawa 
  920-1192 Japan. 
