From: "Ferry Huberts" <ferry@Hupie.com>
Subject: Re: PATCH: new match: userindex
Date: Wed, 8 Dec 2004 15:04:09 +0100 (CET)
Message-ID: <12701.217.169.232.210.1102514649.squirrel@hupie.xs4all.nl>
References: <3801.217.169.232.210.1102511374.squirrel@hupie.xs4all.nl>
	<20041208131834.GA20371@oknodo.bof.de>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20041208131834.GA20371@oknodo.bof.de>
To: netfilter-devel@lists.netfilter.org
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

>> Kernel module for attaching a user specified index to a rule.
>> It matches every packet in order to have no influence on packet
>> matching,
>> the only effect is to add a user index to a rule
>
> I think this is already covered - in extended form, i.e. arbitrary string
> instead of an integer - by the comment match, found in patch-o-matic.
>

I know, but I needed a leaner module so I wrote one and submitted it.
Also, using a number is much simpler, at least for me :-)

I derive rule index numbers dynamically from peer information

> best regards
>   Patrick
>



--
Ferry Huberts
