From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 08:38:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40613AE1.4060800@yahoo.it>
References: <Pine.LNX.4.44.0403240105250.15222-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Scott MacKay <scottmackay@yahoo.com>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403240105250.15222-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>>I wanted to mark up packets with information as they pass thru the
>>system. Basically, I want to associate some data with a packet during
>>PREROUTING/raw (to read info prior to conntrack) and then get that
>>information back during PREROUTING/mangle.  Is there a module already
>>written which could perform this?
> 
> 
> MARK should be able to do this.
> 

An interesting question about MARK field in SKB structure is: Can I use 
all 32-bit of "nfmark" for adding metadata? Iptables front-end (from 
command line) seems to take mark value as a 8-bit number.

		Mike-Ro-Chanel
