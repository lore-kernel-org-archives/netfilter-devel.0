From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 09:01:38 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403240852150.22258-100000@filer.marasystems.com>
References: <40613AE1.4060800@yahoo.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Scott MacKay <scottmackay@yahoo.com>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike-Ro-Chanel <mikerochanel@yahoo.it>
In-Reply-To: <40613AE1.4060800@yahoo.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 24 Mar 2004, Mike-Ro-Chanel wrote:

> An interesting question about MARK field in SKB structure is: Can I use 
> all 32-bit of "nfmark" for adding metadata?

Yes.

> Iptables front-end (from command line) seems to take mark value as a
> 8-bit number.

What makes you think so?

There is a slight signed bug in the string_to_number function which 
prevents the use of the 2^31 bit, easily fixed by changing it to use 
unsigned.

Regards
Henrik
