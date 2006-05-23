From: Patrick McHardy <kaber@trash.net>
Subject: Re: New extension: CRYPT target
Date: Tue, 23 May 2006 19:07:21 +0200
Message-ID: <44734149.2040900@trash.net>
References: <44708E68.9080508@speedy.com.ar>	<44709CFC.7050007@gmx.net>	<4470D859.7000706@speedy.com.ar>	<4470E716.1090001@gmx.net>	<44724DFE.5030806@speedy.com.ar>	<4473380F.5050102@speedy.com.ar>
	<44733C72.1020008@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <44733C72.1020008@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Gervasio Bernal wrote:
>
>>One possible solution would be to use a file to store the key, and chmod
>>that file.That would be correct?
> 
> 
> No. Still leaves a race. You have to chmod the file before you store the
> key in it. Then it would be ok.

You are both very wrong :) What prevents someone from opening it
before the chmod, and read it afterwards? This is what umask is
for ..
