From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: anyone can help me with ipqdemo?
Date: Mon, 1 Dec 2003 10:34:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312011033090.11847-100000@filer.marasystems.com>
References: <E1AQhqB-0006F8-Pu@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
   "aldem-nf@aldem.net" <aldem-nf@aldem.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fangweiwei <fangweiwei@tom.com>
In-Reply-To: <E1AQhqB-0006F8-Pu@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 1 Dec 2003, Fangweiwei wrote:

>    I have download the ipqdemo and run it in the console as root , but
> the cursor just wait there,and I don't think it works.I am a new user
> ,and I strive to make it work well, but I failed.Can you help me?

Yave you instructed iptables to QUEUE some packets?

If nothing is targeted to QUEUE nothing will get to the application..

Regards
Henrik
