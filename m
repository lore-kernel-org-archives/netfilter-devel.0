From: Alan Turner <alan@suburbia.com.au>
Subject: IMQ patch?
Date: Sun, 4 Jan 2004 21:20:34 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401041020.i04AKYj1011282@freddy.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi folks

[Could you CC me on replies? pretty please :)]

I imagine everyone here is sick of "please include this patch" emails
from users. My apologies in advance. I've searched around a bit and
haven't found anything about this - so here goes.

The IMQ patch adds a dummy device to which egress queueing/shaping
disciplines can be attached. Incoming packets may be redirected to the
IMQ device by adding an entry to the PREROUTING table.

This allows the linux kernel to do ingress shaping, which is *very*
useful if you're on a slow link.

A port of the IMQ device to the 2.6 kernel may be found here:

http://www.digriz.org.uk/jdg-qos-script/index.html

The IMQ device homepage is here:

http://trash.net/~kaber/imq/

Is there any chance of this patch being included in POM, or in the
standard kernel?


Thanks muchly for your time.

Cheers,
Alan





-- 
Alan R. Turner | (02) 9481 8223 | 0413 190 128
Live never to be ashamed of anything you do or say.
