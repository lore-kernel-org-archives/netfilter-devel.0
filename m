From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 12:38:46 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408231234590.21477@filer.marasystems.com>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>  <4127CCF9.2030505@trash.net>
  <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>  <4127E586.5000707@trash.net>
 <1093251429.21197.8.camel@uganda>  <4129BF18.3010204@trash.net>
 <1093257059.21197.106.camel@uganda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, Harald Welte <laforge@netfilter.org>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <1093257059.21197.106.camel@uganda>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 23 Aug 2004, Evgeniy Polyakov wrote:

> If it truncates than we have [avoided] overflow and definetely will not
> write anything after it(except zero-lengh snprintf) since
> __count-count == 0 there.

Not quite.. __count-count <= 0 there..

  char buf[4];

  n = snprintf(buf, sizeof(buf), "xxxxxxxx");

returns 8, indicating that buf needs to be at least 9 octets large for 
this call to succeed.

Regards
Henrik
