Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABAF1DA105;
	Wed,  4 Sep 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725454603; cv=none; b=DuS80Yqu/e7oGeC+kYjlSpR/gtzeNiM6gw3azEihN/FgAhvTxfs0/gfsrFuHb13BJIR+Ud/nNzALUUOxJ5IRMjpwSaV5fuC78vFt3EHU616ANF38gOYm2CpDyc9G5I/Uhqy147UsGC2mQfYNakjknPtfI5iYJelp5Ei3DuWS/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725454603; c=relaxed/simple;
	bh=AEqqzoAnneoSB02PHYheeGp6M47QuXiRUOgCai4++r4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=d1Pn21ne6LbrxzLCb//sgBlsYcsPv55xGZarTMJMBkcv8ws9LG4tm6NBrpAvgQTLNYJ8ghtthiLHCLv7/ZNGrG57FP8TI61wUTMIHzB+xhhxwoF9FchLs8/nAv5wKLNMzH6tnG1425uwz7WNOq2/3W2Le2C+p0j9naGHUZVBuM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WzMt30fpPzyR5c;
	Wed,  4 Sep 2024 20:55:39 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id D9AB218024B;
	Wed,  4 Sep 2024 20:56:36 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 20:56:33 +0800
Message-ID: <655fca48-1d87-5ee2-4e8a-a94f34323c73@huawei-partners.com>
Date: Wed, 4 Sep 2024 15:56:29 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/4] selftests/landlock: Implement per-syscall
 microbenchmarks
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
 <20240816005943.1832694-3-ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240816005943.1832694-3-ivanov.mikhail1@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 kwepemj200016.china.huawei.com (7.202.194.28)

8/16/2024 3:59 AM, Mikhail Ivanov wrote:> diff --git 
a/tools/testing/selftests/landlock/bench/run.sh 
b/tools/testing/selftests/landlock/bench/run.sh
> index afbcbb2ba6aa..582313f689ad 100755
> --- a/tools/testing/selftests/landlock/bench/run.sh
> +++ b/tools/testing/selftests/landlock/bench/run.sh
> @@ -237,14 +242,48 @@ print_overhead()
>   	done < $BASE_TRACE_DUMP
>   }
>   
> +print_overhead_workload()
> +{
> +	print "\nTracing results\n"
> +	print "===============\n"
> +	print "cmd: "
> +	print "%s " $WORKLOAD
> +	print "\n"
> +	print "syscalls: %s\n" $TRACED_SYSCALLS
> +	print "access: %s\n" $ACCESS
> +
> +	print_overhead
> +}
> +
> +print_overhead_microbench()
> +{
> +	print "\nTracing results\n"
> +	print "===============\n"
> +	print "cmd: Microbenchmarks\n"
> +	print "syscalls: %s\n" $TRACED_SYSCALLS
> +
> +	print_overhead
> +}
> +
> +form_trace_cmd()
> +{
> +	trace_cmd=$TRACE_CMD
> +	trace_cmd+=" -e $1 -D $SANDBOX_DELAY -o $TMP_BUF"
> +	trace_cmd+=" $TASKSET -c $CPU_AFFINITY"
> +	trace_cmd+=" $NICE -n -19"
> +
> +	echo $trace_cmd
> +}
> +
>   run_traced_workload()
>   {
> +	trace_cmd=$(form_trace_cmd $TRACED_SYSCALLS)
> +
>   	if [ $1 == 0 ]; then
>   		output=$BASE_TRACE_DUMP
> -		sandbox_cmd=
>   	else
>   		output=$LL_TRACE_DUMP
> -		sandbox_cmd="$SANDBOXER_BIN $SANDBOXER_ARGS"
> +		trace_cmd+="$SANDBOXER_BIN $SANDBOXER_ARGS"

Missing space:
	trace_cmd+=" $SANDBOXER_BIN $SANDBOXER_ARGS"

>   	fi
>   
>   	echo '' > $output
