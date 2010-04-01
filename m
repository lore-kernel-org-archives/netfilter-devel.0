From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 01 Apr 2010 16:33:10 +0200
Message-ID: <4BB4AEA6.5000102@trash.net>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr> <4BB22952.2050305@trash.net> <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com> <4BB473CB.5030300@trash.net> <20100401120536.GF19153@mail.eitzenberger.org> <4BB4ADB6.4080206@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Roman Tsisyk <roman@tsisyk.com>,
	Stig Thormodsrud <stig@vyatta.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BB4ADB6.4080206@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> Holger Eitzenberger wrote:
>> Some bits and pieces may be missing on the kernel side if you need to
>> classify your flows though.  E. g. some IPFIX Aggregrators require the
>> DSCP value for that.
> 
> We can post a patch to add the missing stuff to ctnetlink.

Adding DSCP doesn't work since we don't distinguish connections
by that.
