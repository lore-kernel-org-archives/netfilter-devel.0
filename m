From: patric <pakar@imperialnet.org>
Subject: Re: different bandwidth for each connection
Date: Wed, 11 Jul 2007 14:16:31 +0200
Message-ID: <4694CA1F.1070705@imperialnet.org>
References: <4.4-22817-973625708-1184150309@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4.4-22817-973625708-1184150309@seznam.cz>
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

Hi Thomas,


Sounds like this is a question for the user-list and not the devel.


But here you have a packet-shaping guide. It's for gentoo, but should be 
quite similar on all distributions.

http://gentoo-wiki.com/HOWTO_Packet_Shaping


And if you don't want to manually write the shaper-scripts then have a 
look at either shorewall, that has shaping built in, or have a look at 
wondershaper.


/Patric


tomasnull@seznam.cz wrote:

> Hi *,
>
>  I have an application which opens more TCP sockets,
> what I need to do is
>  limit the bandwidth that each socket may consume
> (possibly to
>  different values). I'm wondering what is the best way
> to do this?
>
> Thanks for your responses
> Tomas
>
>
>   
