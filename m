Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DEC95
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 03:59:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
	id A5B675874B10B; Tue, 28 Nov 2023 12:59:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A385B60C1E800;
	Tue, 28 Nov 2023 12:59:18 +0100 (CET)
Date: Tue, 28 Nov 2023 12:59:18 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] man: proper roff encoding for ~ and ^
In-Reply-To: <ZWXTDX1nuwSc1d0t@orbyte.nwl.cc>
Message-ID: <743540q7-r6q9-8551-rs60-s10q01q36o5p@vanv.qr>
References: <20231125161326.77308-1-jengelh@inai.de> <ZWXTDX1nuwSc1d0t@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Tuesday 2023-11-28 12:46, Phil Sutter wrote:

>On Sat, Nov 25, 2023 at 05:12:50PM +0100, Jan Engelhardt wrote:
>> Fixes: v1.8.10-28-g4b0c168a
>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>> ---
>> I thought I had read the groff_char manual, but perhaps too hastily.
>
>Indeed, and nobody apparently tested the results - at least on my
>system, neither \~ nor \^ produce a visible character with either man or
>html output (produced by mandoc). I can't test PDF right now for some
>font problem.

HTML and PDF are completely different beasts in their own right.
The use of \- e.g. actually breaks copy-and-paste with PDF. But:

 * I am being told that's all expected
   https://lists.gnu.org/archive/html/groff/2023-10/msg00052.html ,
 * manpages' primary target is the console anyway,
 * because copying PDF text injects a helluva lot of other artifacts
   anyway, predominantly newlines

I left PDF documentation being the third-class citizen that it is.
