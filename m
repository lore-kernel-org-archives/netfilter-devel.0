From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 20:33:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <412A3881.7030306@trash.net>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>	 <4127CCF9.2030505@trash.net>	 <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>	 <4127E586.5000707@trash.net> <1093251429.21197.8.camel@uganda>	 <4129BF18.3010204@trash.net>  <1093257059.21197.106.camel@uganda>	 <1093257554.21197.121.camel@uganda> <1093260922.21197.156.camel@uganda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <1093260922.21197.156.camel@uganda>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Evgeniy Polyakov wrote:

>I'm not smoking bad crack, but it needs to be __count <= count + err;
>Attached.
>  
>
This one looks fine, applied.
