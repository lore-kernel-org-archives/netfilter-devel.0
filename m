From: Patrick McHardy <kaber@trash.net>
Subject: Re: IMQ patch?
Date: Mon, 05 Jan 2004 18:30:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FF99F25.1090501@trash.net>
References: <200401041020.i04AKYj1011282@freddy.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alan Turner <alan@suburbia.com.au>
In-Reply-To: <200401041020.i04AKYj1011282@freddy.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Alan,

Alan Turner wrote:

>Hi folks
>
>[Could you CC me on replies? pretty please :)]
>
>I imagine everyone here is sick of "please include this patch" emails
>from users. My apologies in advance. I've searched around a bit and
>haven't found anything about this - so here goes.
>
>The IMQ patch adds a dummy device to which egress queueing/shaping
>disciplines can be attached. Incoming packets may be redirected to the
>IMQ device by adding an entry to the PREROUTING table.
>
>This allows the linux kernel to do ingress shaping, which is *very*
>useful if you're on a slow link.
>
>A port of the IMQ device to the 2.6 kernel may be found here:
>
>http://www.digriz.org.uk/jdg-qos-script/index.html
>
>The IMQ device homepage is here:
>
>http://trash.net/~kaber/imq/
>  
>

The IMQ device is buggy and unmaintained, it really shouldn't be
included anywhere until someone takes maintainership and fixes
the problems.

Best regards,
Patrick

>Is there any chance of this patch being included in POM, or in the
>standard kernel?
>
>
>Thanks muchly for your time.
>
>Cheers,
>Alan
>
>
>
>
>
>  
>
